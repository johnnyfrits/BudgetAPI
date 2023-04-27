namespace BudgetAPI.Models
{
    public class CardsInvoiceDate
    {
        public int Id { get; set; }
        public string Reference { get; set; }
        public int CardId { get; set; }
        public DateTime InvoiceStart { get; set; }
        public DateTime InvoiceEnd { get; set; }
        public int UserId { get; set; }
    }
}
